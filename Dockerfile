FROM judge0/judge0:1.13.0

# Install curl for health checks
USER root
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Create a custom entrypoint script
RUN echo '#!/bin/bash\n\
set -e\n\
\n\
# Use Render'\''s PORT or default to 2358\n\
export JUDGE0_PORT=${PORT:-2358}\n\
\n\
# Update the Rails server to bind to 0.0.0.0 and the correct port\n\
export RAILS_SERVER_BINDING="0.0.0.0"\n\
export RAILS_SERVER_PORT="$JUDGE0_PORT"\n\
\n\
# Start Judge0 with the correct port binding\n\
exec bundle exec rails server -b 0.0.0.0 -p $JUDGE0_PORT' > /usr/local/bin/custom-entrypoint.sh

RUN chmod +x /usr/local/bin/custom-entrypoint.sh

# Switch back to judge0 user
USER judge0

EXPOSE $PORT

ENTRYPOINT ["/usr/local/bin/custom-entrypoint.sh"]