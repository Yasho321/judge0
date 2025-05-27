FROM judge0/judge0:1.13.0

# Switch to root to install dependencies and modify files
USER root

# Install curl for health checks
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Create a simple startup script that binds to the correct port
RUN cat > /start-judge0.sh << 'EOF'
#!/bin/bash
set -e

# Use Render's PORT environment variable or default to 2358
BIND_PORT=${PORT:-2358}

echo "Starting Judge0 on port $BIND_PORT"

# Start Judge0 with correct port binding
cd /judge0
exec bundle exec rails server -b 0.0.0.0 -p $BIND_PORT -e production
EOF

RUN chmod +x /start-judge0.sh

# Switch back to judge0 user
USER judge0

# Expose the port
EXPOSE $PORT

# Use our custom startup script
CMD ["/start-judge0.sh"]