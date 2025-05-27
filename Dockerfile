FROM judge0/judge0:1.13.0

# Switch to root to install dependencies
USER root

# Install curl for health checks
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Create startup script with proper syntax
RUN echo '#!/bin/bash\n\
export BIND_PORT=${PORT:-2358}\n\
echo "Starting Judge0 on port $BIND_PORT"\n\
cd /judge0\n\
exec bundle exec rails server -b 0.0.0.0 -p $BIND_PORT -e production' > /start-judge0.sh

RUN chmod +x /start-judge0.sh

# Switch back to judge0 user
USER judge0

# Expose port
EXPOSE $PORT

# Use our startup script
CMD ["/start-judge0.sh"]