Purpose: produce a secure webhook secret and optionally register it in FOSSBilling/CloudPanel.

Generate secret:

WEBHOOK_SECRET=$(openssl rand -hex 32)
echo "WEBHOOK_SECRET=${WEBHOOK_SECRET}" > /etc/cloudpanel-foss/webhook.env
chmod 600 /etc/cloudpanel-foss/webhook.env


Register webhook on FOSSBilling (manual or API):

If FOSSBilling has an API for webhooks, call it with the secret and the target URL (CloudPanel endpoint). Example:

curl -X POST https://foss.example/api/webhooks \
  -H "Authorization: Bearer <admin-api-token>" \
  -H "Content-Type: application/json" \
  -d '{"url":"https://cloudpanel.example/api/webhook","secret":"'"${WEBHOOK_SECRET}"'","events":["invoice.paid","client.created"]}'


Test webhook:

curl -X POST https://cloudpanel.example/api/webhook \
  -H "X-Webhook-Secret: ${WEBHOOK_SECRET}" \
  -H "Content-Type: application/json" \
  -d '{"test":"ok"}' -v


Store the secret securely: Ansible Vault, Azure Key Vault, or GitHub Secrets — never commit it.
