import * as cluster from 'cluster';

const origin = 'syuilo/accesses';

/**
 * Init event system
 * この関数は必ずmasterプロセスで呼び出します。
 * クラスタ上で動いてない場合、この関数の呼出は必要ありません。
 */
export function init() {
	// When receiving a message from workers
	cluster.on('message', (sender, message) => {
		// Ignore non accesses messages
		if (message.origin != origin) return;

		// Broadcast the message to all workers
		for (const id in cluster.workers) {
			const worker = cluster.workers[id];
			worker.send(message);
		}
	});
}

/**
 * Publish event
 */
export function pub(type, data) {
	const message = { type, data, origin };

	if (cluster.isMaster) {
		// クラスタ上で動いている場合
		if (Object.keys(cluster.workers).length > 0) {
			// Each all workers
			for (const id in cluster.workers) {
				const worker = cluster.workers[id];
				worker.send(message);
			}
		} else {
			process.emit('message', message);
		}
	} else {
		process.send(message);
	}
}

/**
 * Subscribe event
 * @param handler
 */
export function sub(handler) {
	process.on('message', message => {
		// Ignore non accesses messages
		if (message.origin != origin) return;
		delete message.origin;
		handler(message);
	});
}