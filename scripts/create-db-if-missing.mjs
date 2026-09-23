// 幂等建库：连接 postgres 库，若目标库不存在则创建
// 用法：node scripts/create-db-if-missing.mjs [数据库名]
import { createRequire } from 'node:module';
const require = createRequire(import.meta.url);
const { Client } = require('../node_modules/.pnpm/pg@8.22.0/node_modules/pg');

const dbName = process.argv[2] || 'qunxiang';
const client = new Client({
  host: '127.0.0.1',
  port: 5432,
  user: 'qunxiang',
  password: 'change_me',
  database: 'postgres',
});

await client.connect();
const res = await client.query('SELECT 1 FROM pg_database WHERE datname = $1', [dbName]);
if (res.rowCount === 0) {
  await client.query(`CREATE DATABASE "${dbName}"`);
  console.log(`[DB] 已创建数据库 ${dbName}`);
} else {
  console.log(`[DB] 数据库 ${dbName} 已存在，跳过`);
}
await client.end();
