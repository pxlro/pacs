version: "3.8"
services:
  dockge:
    image: louislam/dockge:1
    restart: unless-stopped
    ports:
      - 5001:5001
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./data:/app/data
      # Stacks Directory
      # ⚠️ READ IT CAREFULLY. If you did it wrong, your data could end up writing into a WRONG PATH.
      # ⚠️ 1. FULL path only. No relative path (MUST)
      # ⚠️ 2. Left Stacks Path === Right Stacks Path (MUST)
      - /opt/stacks:/opt/stacks
    environment:
      # Tell Dockge where to find the stacks
      - DOCKGE_STACKS_DIR=/opt/stacks
  pacs:
    image: orthancteam/orthanc
    restart: unless-stopped
    ports: ["443:443"]
    volumes:
      - orthanc-storage:/var/lib/orthanc/db/
      - ./tls:/tls
    environment:
      DICOM_WEB_PLUGIN_ENABLED: "true"
      OHIF_PLUGIN_ENABLED: "true"
      ORTHANC_JSON: |
        {
          "Name" : "Orthanc for HTTPS tests",
          "AuthenticationEnabled": false,
          "OHIF": {
            "DataSource": "dicom-web"
          },
          "RemoteAccessAllowed": true,
          "SslEnabled": true,
          "SslCertificate": "/tls/orthanc-https.pem",
          "HttpPort": 443
        }
      VERBOSE_ENABLED: "true"
      VERBOSE_STARTUP: "true"
volumes:
  orthanc-storage:
