# autobrr + cross-seed Setup

## Prerequisites (manual — before deploying)

1. **Fill in secrets**, then seal them:

   ```bash
   # Generate and insert real values
   sed -i "s/REPLACE_WITH_RANDOM_SECRET/$(openssl rand -hex 32)/" base/htpc/autobrr/secrets.yaml
   sed -i "s/REPLACE_WITH_RANDOM_KEY/$(openssl rand -hex 32)/" base/htpc/crossseed/secrets.yaml

   # Seal both in-place
   ./scripts/seal-secrets.sh
   ```

2. Note the generated `CROSSSEED_API_KEY` value — you'll need it in autobrr.

---

## autobrr (`autobrr.my-homelab.party`)

On first launch, create an admin account via the UI.

### Add download clients (Settings → Clients)

| Client | URL | Purpose |
|--------|-----|---------|
| Sonarr | `http://sonarr.htpc.svc.cluster.local:8989` | TV series |
| Radarr | `http://radarr.htpc.svc.cluster.local:7878` | Movies |
| Transmission | `http://transmission.htpc.svc.cluster.local:9091` | Direct grabs (optional) |

Use the respective API keys from your existing arr stack.

### Add indexers (Settings → Indexers)

- Add Prowlarr: URL `http://prowlarr.htpc.svc.cluster.local:9696`
- Add IRC announce channels per tracker (requires tracker credentials and announce keys)
- Add RSS feeds as needed

### Add cross-seed webhook filter

1. Create a new Filter
2. Set action → **Webhook**
3. URL: `http://crossseed.htpc.svc.cluster.local:2468/api/webhook`
4. Headers: `X-Api-Key: <your CROSSSEED_API_KEY>`
5. Data: `{"name": "{{ .TorrentName }}", "infoHash": "{{ .InfoHash }}"}`

---

## cross-seed (`crossseed.my-homelab.party`)

cross-seed configuration is managed via the ConfigMap `cross-seed-config` in
`base/htpc/crossseed/configmap.yaml`. Edit the file and redeploy to apply changes.

### Add Prowlarr Torznab indexer URLs

1. In Prowlarr: Settings → Indexers → click an indexer → copy the **Torznab Feed** URL
2. Edit `base/htpc/crossseed/configmap.yaml` and add to the `torznab` array:

   ```js
   torznab: [
     `http://prowlarr.htpc.svc.cluster.local:9696/1/api?apikey=YOUR_PROWLARR_API_KEY`,
     // add more indexers...
   ],
   ```

3. Redeploy: `kubectl rollout restart deployment/crossseed -n htpc`

### Optional: Sonarr/Radarr integration (improves title matching)

Add to `config.js` inside the ConfigMap:

```js
sonarr: [{ url: "http://sonarr.htpc.svc.cluster.local:8989", apiKey: "YOUR_SONARR_KEY" }],
radarr: [{ url: "http://radarr.htpc.svc.cluster.local:7878", apiKey: "YOUR_RADARR_KEY" }],
```

### Trigger a full library scan (one-time)

After deploying, run a cross-seed search on your entire library:

```bash
kubectl exec -n htpc deployment/crossseed -- cross-seed search
```
