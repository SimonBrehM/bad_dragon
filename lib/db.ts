// /lib/db.ts
import sql from "mssql";

const config: sql.config = {
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  server: process.env.DB_HOST!,
  database: process.env.DB_NAME,
  options: {
    encrypt: true,
    trustServerCertificate: true,
  },
  pool: {
    max: 10,
    min: 0,
    idleTimeoutMillis: 30000,
  },
};

declare global {
  var _sqlPool: sql.ConnectionPool | undefined;
  var _sqlPoolPromise: Promise<sql.ConnectionPool> | undefined;
}

export async function getPool(): Promise<sql.ConnectionPool> {
  // Reuse resolved pool if valid
  if (global._sqlPool && global._sqlPool.connected) {
    return global._sqlPool;
  }

  // If a connection is in progress, await it
  if (global._sqlPoolPromise) {
    return global._sqlPoolPromise;
  }

  // Create new connection promise
  global._sqlPoolPromise = new sql.ConnectionPool(config)
    .connect()
    .then((pool) => {
      // Attach error handler to auto-reset on failure
      pool.on("error", (err) => {
        console.error("SQL pool error:", err);

        // Invalidate pool so next request reconnects
        global._sqlPool = undefined;
        global._sqlPoolPromise = undefined;
      });

      global._sqlPool = pool;
      return pool;
    })
    .catch((err) => {
      // Reset promise so future attempts retry
      global._sqlPoolPromise = undefined;
      throw err;
    });

  return global._sqlPoolPromise;
}
