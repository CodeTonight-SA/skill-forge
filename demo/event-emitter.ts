type EventCallback<T = unknown> = (data: T) => void;

interface EventEmitter {
  on<T>(event: string, callback: EventCallback<T>): () => void;
  off<T>(event: string, callback: EventCallback<T>): void;
  emit<T>(event: string, data: T): void;
  once<T>(event: string, callback?: EventCallback<T>): Promise<T> & { unsubscribe: () => void };
  clear(event?: string): void;
}

function createEventEmitter(): EventEmitter {
  const listeners = new Map<string, Set<EventCallback>>();

  const on = <T>(event: string, callback: EventCallback<T>): (() => void) => {
    if (!listeners.has(event)) {
      listeners.set(event, new Set());
    }
    listeners.get(event)!.add(callback as EventCallback);
    return () => off(event, callback);
  };

  const off = <T>(event: string, callback: EventCallback<T>): void => {
    listeners.get(event)?.delete(callback as EventCallback);
  };

  const emit = <T>(event: string, data: T): void => {
    listeners.get(event)?.forEach(cb => cb(data));
  };

  const clear = (event?: string): void => {
    event ? listeners.delete(event) : listeners.clear();
  };

  const once = <T>(event: string, callback?: EventCallback<T>): Promise<T> & { unsubscribe: () => void } => {
    let unsubscribe: () => void;

    const promise = new Promise<T>((resolve) => {
      const wrapper: EventCallback<T> = (data) => {
        off(event, wrapper);
        callback?.(data);
        resolve(data);
      };
      unsubscribe = on(event, wrapper);
    }) as Promise<T> & { unsubscribe: () => void };

    promise.unsubscribe = () => unsubscribe();
    return promise;
  };

  return { on, off, emit, once, clear };
}

export { createEventEmitter, EventEmitter, EventCallback };
