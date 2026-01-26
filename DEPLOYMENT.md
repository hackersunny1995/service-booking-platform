# Deployment Guide - Homeprime99

This guide walks you through deploying the Homeprime99 service booking platform to production.

## Overview

- **Backend**: Render.com (Free tier)
- **Database**: Supabase PostgreSQL (Already configured)
- **Frontend**: GitHub Pages (Free)

## Pre-Deployment Checklist

✅ Supabase database configured
✅ Backend updated for PostgreSQL
✅ Flutter app with complete booking flow
✅ README documentation complete

## Step-by-Step Deployment

### 1. Initialize Git and Push to GitHub

```bash
# Navigate to project root
cd /Users/sunilkumar/service-booking-platform

# Initialize Git (if not already)
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit: Complete booking flow with Supabase integration"

# Create GitHub repository (via GitHub CLI or web)
# Option 1: Using GitHub CLI
gh repo create service-booking-platform --public --source=. --remote=origin

# Option 2: Manual (create repo on github.com, then):
git remote add origin https://github.com/YOUR-USERNAME/service-booking-platform.git

# Push to GitHub
git branch -M main
git push -u origin main
```

### 2. Deploy Backend to Render

1. **Sign up** at [Render.com](https://render.com)

2. **Create New Web Service**:
   - Click "New +" → "Web Service"
   - Connect your GitHub account
   - Select `service-booking-platform` repository
   - Configure:
     - **Name**: `homeprime99-backend`
     - **Region**: Choose closest to your users
     - **Branch**: `main`
     - **Root Directory**: `backend`
     - **Runtime**: `Java`
     - **Build Command**: `./mvnw clean package -DskipTests`
     - **Start Command**: `java -Dserver.port=$PORT -Dspring.profiles.active=prod -jar target/*.jar`

3. **Environment Variables** (add these):
   ```
   SPRING_PROFILES_ACTIVE=prod
   SPRING_DATASOURCE_URL=jdbc:postgresql://db.jyrpmaqkvpxbcstnogap.supabase.co:5432/postgres
   SPRING_DATASOURCE_USERNAME=postgres
   SPRING_DATASOURCE_PASSWORD=Home@prime#$
   JWT_SECRET=homeprime99-super-secret-jwt-key-change-this-to-something-more-secure-in-production
   CORS_ALLOWED_ORIGINS=https://YOUR-GITHUB-USERNAME.github.io
   ```

4. **Deploy**: Click "Create Web Service"
   - First deployment takes 5-10 minutes
   - Wait for "Live" status
   - Note your backend URL (e.g., `https://homeprime99-backend.onrender.com`)

5. **Verify Backend**:
   - Open: `https://homeprime99-backend.onrender.com/api/categories`
   - Should return empty array `[]` or categories if migrations ran

### 3. Update Flutter Configuration

Edit `user-app/lib/config/api_config.dart`:

```dart
static String get baseUrl {
  if (kIsWeb) {
    // PRODUCTION: Replace with your actual Render URL
    return 'https://homeprime99-backend.onrender.com/api';
  }
  return 'http://10.0.2.2:8080/api'; // Android emulator
}
```

**Commit and push this change:**
```bash
git add user-app/lib/config/api_config.dart
git commit -m "Update API URL for production deployment"
git push
```

### 4. Build Flutter Web App

```bash
cd user-app
flutter build web --release --web-renderer html
```

This creates optimized build in `user-app/build/web/`

### 5. Deploy to GitHub Pages

**Option A: Using gh-pages npm package (Recommended)**

```bash
# Install gh-pages globally (one-time)
npm install -g gh-pages

# From user-app directory
cd user-app
gh-pages -d build/web
```

This automatically creates a `gh-pages` branch and deploys.

**Option B: Manual deployment**

```bash
# From project root
cp -r user-app/build/web docs/
git add docs/
git commit -m "Deploy Flutter web app"
git push
```

Then in GitHub:
- Go to Settings → Pages
- Source: `main` branch, `/docs` folder
- Save

### 6. Enable GitHub Pages

1. Go to your repository on GitHub
2. Click **Settings**
3. Click **Pages** (left sidebar)
4. Under "Source":
   - **Branch**: Select `gh-pages` (Option A) or `main` (Option B)
   - **Folder**: `/` (root) for gh-pages or `/docs` for manual
5. Click **Save**

Your site will be published at:
`https://YOUR-GITHUB-USERNAME.github.io/service-booking-platform/`

Wait 2-3 minutes for deployment to complete.

### 7. Update CORS on Backend

Once you have your GitHub Pages URL, update CORS:

1. Go to Render dashboard
2. Select `homeprime99-backend` service
3. Click "Environment" tab
4. Update `CORS_ALLOWED_ORIGINS`:
   ```
   https://YOUR-GITHUB-USERNAME.github.io
   ```
5. Save and redeploy

### 8. Test Everything

1. **Open frontend**: `https://YOUR-GITHUB-USERNAME.github.io/service-booking-platform/`

2. **Register a new account**:
   - Click "Sign Up"
   - Enter email, name, phone, password
   - Should successfully register

3. **Login**:
   - Use credentials you just created
   - Should navigate to home screen

4. **Browse services**:
   - Click a category (e.g., "Plumbing")
   - View services

5. **Test booking flow**:
   - Select a service
   - Click "Book Now"
   - Complete all 4 steps
   - Verify booking created

6. **Check "My Bookings"**:
   - Menu → My Bookings
   - Should see your test booking

## Troubleshooting

### Backend Issues

**Build fails on Render:**
- Check Java version (must be 17)
- Verify `./mvnw` has execute permissions
- Check build logs for specific errors

**Database connection fails:**
- Verify Supabase URL is correct
- Check password doesn't have special characters needing escaping
- Ensure Supabase project is active

**CORS errors:**
- Verify `CORS_ALLOWED_ORIGINS` matches exact GitHub Pages URL
- No trailing slash in URL
- Check browser console for exact origin being blocked

### Frontend Issues

**Blank white screen:**
- Check browser console for errors
- Verify API URL in `api_config.dart`
- Check if backend is sleeping (Render free tier sleeps after inactivity)

**API calls fail:**
- Wake up backend by visiting URL directly
- Check network tab in browser DevTools
- Verify backend is deployed and live

**Location/GPS not working:**
- GitHub Pages must use HTTPS (it does by default)
- Grant location permissions when prompted
- Try on different browser if issues persist

## Free Tier Limitations

### Render.com
- ⏰ Sleeps after 15 min inactivity
- 🐌 First request after sleep takes 30-60 seconds
- 💾 750 hours/month free

**Solution**: If demo is slow, wait 30-60s for backend to wake up

### GitHub Pages
- ✅ Always on, fast
- ✅ 1GB storage limit
- ✅ Unlimited static hosting

## URLs Summary

After deployment, update README.md with actual URLs:

- **Frontend**: `https://YOUR-GITHUB-USERNAME.github.io/service-booking-platform/`
- **Backend**: `https://homeprime99-backend.onrender.com/api`
- **GitHub Repo**: `https://github.com/YOUR-GITHUB-USERNAME/service-booking-platform`

## Monitoring

### Backend Logs (Render)
- Dashboard → homeprime99-backend → Logs tab
- Monitor API calls, errors, database connections

### Frontend (Browser Console)
- Open DevTools (F12)
- Check Console for errors
- Check Network tab for API calls

## Next Steps

After successful deployment:

1. **Test thoroughly** with different scenarios
2. **Share demo URL** with stakeholders
3. **Gather feedback**
4. **Iterate** and improve

## Support

If you encounter issues:

1. Check logs (Render for backend, browser console for frontend)
2. Review troubleshooting section above
3. Verify all environment variables are set correctly
4. Ensure Supabase database is accessible

---

**Important**: Remember to update the README.md with your actual deployment URLs once everything is live!
