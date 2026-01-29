# Deploy to Railway.app

## Step 1: Sign Up for Railway
1. Go to https://railway.app/
2. Click "Start a New Project"
3. Sign up with GitHub

## Step 2: Deploy Backend

### Option A: Deploy from GitHub (Recommended)
1. Click "Deploy from GitHub repo"
2. Select `hackersunny1995/service-booking-platform`
3. Click on the deployed service
4. Go to "Settings" → "Root Directory" → Set to `backend`
5. Railway will auto-detect the Java app and deploy

### Option B: Deploy with Railway CLI
```bash
# Install Railway CLI
npm install -g @railway/cli

# Login to Railway
railway login

# Navigate to backend directory
cd backend

# Initialize and deploy
railway init
railway up
```

## Step 3: Configure Environment Variables

In Railway dashboard, go to your service → Variables, add:

```
SPRING_DATASOURCE_URL=jdbc:postgresql://aws-1-ap-south-1.pooler.supabase.com:6543/postgres?sslmode=require&prepareThreshold=0&preferQueryMode=simple
SPRING_DATASOURCE_USERNAME=postgres.jyrpmaqkvpxbcstnogap
SPRING_DATASOURCE_PASSWORD=Home@prime#$
JWT_SECRET=homeprime99-secret-key-change-this-in-production-make-it-very-long-and-secure
RAZORPAY_KEY_ID=rzp_test_1DP5mmOlF5G5ag
RAZORPAY_KEY_SECRET=<YOUR_RAZORPAY_SECRET>
SPRING_PROFILES_ACTIVE=prod
```

## Step 4: Get Your Backend URL

After deployment completes:
1. Go to Settings → Networking
2. Click "Generate Domain"
3. Copy the URL (e.g., `https://your-app.railway.app`)

## Step 5: Update Flutter App

Update API base URL in `user-app/lib/config/api_config.dart`:
```dart
static const String baseUrl = 'https://your-app.railway.app';
```

## Step 6: Redeploy Flutter App

```bash
cd user-app
flutter build web --base-href "/service-booking-platform/" --release
git add .
git commit -m "Update API URL to Railway"
git push origin main
```

## Railway Free Tier Limits
- 500 hours/month (about 21 days)
- $5 free credits
- Much better for Spring Boot apps than Render free tier
