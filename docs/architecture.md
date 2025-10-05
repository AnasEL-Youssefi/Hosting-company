High-level diagram: components (Azure VM, Nginx, PHP-FPM, MariaDB, CloudPanel, FOSSBilling, Webhook channel). Use Mermaid for an embedded diagram:

```mermaid
graph LR
  Client -->|HTTPS| NGINX
  NGINX --> PHPFPM
  PHPFPM --> FOSSBilling
  FOSSBilling -->|webhook| CloudPanelAPI
  CloudPanelAPI --> CloudPanel
  CloudPanel --> DB[(MariaDB)]


Network & ports: list inbound/outbound ports and why they are open (22,80,443,3306,9999).

Data flow: sequence for a purchase -> invoice -> webhook -> CloudPanel creates site.

Storage & backups: describe where DB dumps and filesystem backups go (e.g., Azure Storage).

Security: TLS termination, vaults for secrets, minimal NSG rules.

Scaling/HA: notes for production (separate DB server, load balancer, autoscale).
