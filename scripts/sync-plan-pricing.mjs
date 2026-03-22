import { spawnSync } from "node:child_process"
import path from "node:path"
import { fileURLToPath } from "node:url"

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)
const workspaceRoot = path.resolve(__dirname, "..")
const syncScriptPath = path.resolve(
  workspaceRoot,
  "api.charlarapp.com",
  "scripts",
  "sync-plan-pricing.mjs",
)

const result = spawnSync(process.execPath, [syncScriptPath, ...process.argv.slice(2)], {
  cwd: workspaceRoot,
  stdio: "inherit",
})

if (result.error) {
  throw result.error
}

process.exit(result.status ?? 1)
