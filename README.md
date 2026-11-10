# packets-keepwarm

Pings the Packets sites every few minutes so Vercel functions and the Neon databases behind them do not go to sleep
(the first visit after a quiet spell was taking 1.5 to 6 seconds).

- `targets.txt`: the URLs to ping (public GET requests, no secrets).
- `.github/workflows/keepwarm.yml`: runs every 5 minutes; each run pings every 60 seconds for about 4 minutes.
- `.github/workflows/keepalive.yml`: one commit a month so GitHub does not disable the schedule after 60 days of inactivity.

This repo must be **public**: Actions minutes are free and unlimited for public repos, but a private repo would use up
the free monthly minutes and could block other workflows. Do not put secrets or private URLs in it.

Note: GitHub runs scheduled workflows late at busy times, so this is best-effort. For a stricter schedule add the same
URLs to an uptime monitor (Better Stack every 3 minutes, cron-job.org every minute).
Run it by hand: `scripts/ping.sh` (one round) or Actions > keep-warm > Run workflow.
