package com.servicebooking.service;

import com.servicebooking.dto.AuthResponse;
import com.servicebooking.dto.LoginRequest;
import com.servicebooking.dto.RegisterRequest;
import com.servicebooking.exception.BadRequestException;
import com.servicebooking.model.ProviderProfile;
import com.servicebooking.model.User;
import com.servicebooking.model.UserRole;
import com.servicebooking.repository.ProviderProfileRepository;
import com.servicebooking.repository.UserRepository;
import com.servicebooking.security.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final ProviderProfileRepository providerProfileRepository;
    private final PasswordEncoder passwordEncoder;
    private final AuthenticationManager authenticationManager;
    private final JwtTokenProvider tokenProvider;

    @Transactional
    public AuthResponse register(RegisterRequest request) {
        // Check if user already exists
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new BadRequestException("Email already exists");
        }

        // Create new user
        User user = new User();
        user.setEmail(request.getEmail());
        user.setPasswordHash(passwordEncoder.encode(request.getPassword()));
        user.setFullName(request.getFullName());
        user.setPhone(request.getPhone());
        user.setRole(request.getRole());
        user.setAddress(request.getAddress());
        user.setCity(request.getCity());
        user.setState(request.getState());
        user.setPincode(request.getPincode());
        user.setIsVerified(false);
        user.setIsActive(true);

        user = userRepository.save(user);

        // If provider, create provider profile
        if (request.getRole() == UserRole.PROVIDER) {
            ProviderProfile providerProfile = new ProviderProfile();
            providerProfile.setUser(user);
            providerProfile.setBio(request.getBio());
            providerProfile.setExperienceYears(request.getExperienceYears());
            if (request.getServiceRadiusKm() != null) {
                providerProfile.setServiceRadiusKm(request.getServiceRadiusKm());
            }
            providerProfile.setIsAvailable(false);
            providerProfile.setIsApproved(false);
            providerProfileRepository.save(providerProfile);
        }

        // Authenticate and generate token
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword())
        );

        SecurityContextHolder.getContext().setAuthentication(authentication);
        String jwt = tokenProvider.generateToken(authentication);

        return new AuthResponse(jwt, user.getId(), user.getEmail(), user.getFullName(), user.getRole());
    }

    public AuthResponse login(LoginRequest request) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword())
        );

        SecurityContextHolder.getContext().setAuthentication(authentication);
        String jwt = tokenProvider.generateToken(authentication);

        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new BadRequestException("User not found"));

        return new AuthResponse(jwt, user.getId(), user.getEmail(), user.getFullName(), user.getRole());
    }
}
