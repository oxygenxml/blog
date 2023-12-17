FROM eclipse-temurin:17-jre

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

LABEL "maintainer"="Syncro Soft (Oxygen XML)"
LABEL "org.opencontainers.image.authors"="https://www.oxygenxml.com"
LABEL "org.opencontainers.image.documentation"="https://www.oxygenxml.com/publishing_engine.html"
LABEL "org.opencontainers.image.vendor"="Syncro Soft (Oxygen XML)"
LABEL "org.opencontainers.image.licenses"="Oxygen XML License"
LABEL "org.opencontainers.image.title"="Oxygen Publishing Engine"
LABEL "org.opencontainers.image.description"="Oxygen Publishing Engine (based on the DITA OT) for content authored in the Darwin Information Typing Architecture."
LABEL "org.opencontainers.image.source"="https://www.oxygenxml.com/publishing_engine.html"

RUN export DEBIAN_FRONTEND=noninteractive
# Install unzip utility
RUN apt-get update -q
RUN apt-get install -qy --no-install-recommends -y unzip
# Remove cache left by apt-get
RUN rm -rf /var/lib/apt/lists/*

# Download oxygen publishing engine and copy it to the /opt/app/ folder
RUN curl -sLo /tmp/dita-ot.zip https://www.oxygenxml.com/InstData/PublishingEngine/oxygen-publishing-engine.zip
RUN unzip -qq /tmp/dita-ot.zip -d /tmp/
RUN mv /tmp/oxygen-publishing-engine /tmp/dita-ot
RUN rm /tmp/dita-ot.zip
RUN mkdir -p /opt/app
RUN mv /tmp/dita-ot /opt/app/
RUN chmod 755 /opt/app/dita-ot/bin/dita

# Create the script which creates the license key on disk 
# before running the transformation and then invokes the dita script
RUN echo "#! /bin/sh" >> /opt/app/dita-ot/bin/setup
# RUN echo "LICENSE_KEY_NEW_LINES=\$(echo \"\$LICENSE_KEY\" | tr '  ' '\n')" >> /opt/app/dita-ot/bin/setup
RUN echo "echo \"\$LICENSE_KEY\" > /opt/app/dita-ot/licensekey.txt" >> /opt/app/dita-ot/bin/setup
RUN echo "sed -i 's/  /\n/g' /opt/app/dita-ot/licensekey.txt" >> /opt/app/dita-ot/bin/setup
RUN echo "/opt/app/dita-ot/bin/dita \$@" >> /opt/app/dita-ot/bin/setup
RUN echo "rm -rf /opt/app/dita-ot/licensekey.txt" >> /opt/app/dita-ot/bin/setup
RUN chmod 755 /opt/app/dita-ot/bin/setup
RUN chmod +x /opt/app/dita-ot/bin/setup

# Create a particular user under which to run the build.
RUN useradd -ms /bin/bash dita-ot
RUN chown -R dita-ot:dita-ot /opt/app/dita-ot
USER dita-ot

# Set env variables and define the entry point.
ENV DITA_HOME=/opt/app/dita-ot
ENV PATH=${PATH}:${DITA_HOME}/bin
WORKDIR $DITA_HOME
ENTRYPOINT ["/opt/app/dita-ot/bin/setup"]
