# Redis Failover Setup

This setup provides multiple ways to run Redis with fallback support between Bitnami Redis and superset-redis images.

## Available Options

### Option 1: Automatic Failover Script (Recommended)
Use the provided shell script that automatically tries Bitnami first and falls back to superset-redis:

```bash
./start-redis.sh
```

### Option 2: Manual Profile Selection
Use Docker Compose profiles to manually select which Redis to run:

**Run Bitnami Redis (default):**
```bash
docker compose --profile bitnami up -d
# or simply
docker compose up -d
```

**Run superset-redis as fallback:**
```bash
docker compose --profile fallback up -d
```

### Option 3: Override File Approach
Use the fallback override file when Bitnami is not available:

**Normal startup (Bitnami):**
```bash
docker compose up -d
```

**Fallback startup (superset-redis):**
```bash
docker compose -f docker-compose.yml -f docker-compose.fallback.yml up -d
```

## Images Used

- **Primary**: `docker.io/bitnami/redis:8.2` (Official Bitnami Redis)
- **Fallback**: `felipemoreira1/superset-redis:1.0` (Custom Ubuntu-based Redis)

## Data Persistence

Both setups use the same volume (`redis_data`) but with different mount points:
- Bitnami: `/bitnami/redis/data`
- Superset-redis: `/data`

## Health Checking

The automatic script includes health checks using `redis-cli ping` to ensure the service is actually responding before considering it successful.

## Stopping Services

```bash
# Stop current running services
docker compose down

# Stop specific profile
docker compose --profile bitnami down
docker compose --profile fallback down
```