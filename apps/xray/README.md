# Xray VLESS + XTLS-Reality VPN

Xray proxy server with VLESS protocol and XTLS-Reality security to bypass internet censorship.

### Configure via Web UI

1. Open https://xray.lavrov.nl
2. Login to web-ui with default credentials: admin/admin
3. Go to "Inbounds" → "+" to add VLESS inbound:
   - **Remark**: Give it a name (e.g., "Home VPN")
   - **Port**: `31002` (must match NodePort)
   - **Protocol**: `VLESS`
   - **Security**: `Reality`
   - **Dest**: `www.microsoft.com:443`
   - **Server Names**: `www.microsoft.com`
   - **Private Key**: generate
   - **SpiderX**: `/` (or leave empty)
   
   3X-UI will automatically derive and display the **Public Key** - save this!

4. **Add a user** (Clients tab):
   - Click "+" to add client
   - **UUID**: Generate random UUID or use existing
   - **Flow**: `xtls-rprx-vision`
   - **Email**: Optional identifier
