import { createEventEmitter } from './event-emitter';

describe('EventEmitter', () => {
  it('should emit events to subscribers', () => {
    const emitter = createEventEmitter();
    const callback = jest.fn();

    emitter.on('test', callback);
    emitter.emit('test', { value: 42 });

    expect(callback).toHaveBeenCalledWith({ value: 42 });
  });

  it('should allow unsubscribing', () => {
    const emitter = createEventEmitter();
    const callback = jest.fn();

    const unsubscribe = emitter.on('test', callback);
    unsubscribe();
    emitter.emit('test', 'data');

    expect(callback).not.toHaveBeenCalled();
  });

  it('should support once with Promise', async () => {
    const emitter = createEventEmitter();

    setTimeout(() => emitter.emit('ready', 'done'), 10);

    const result = await emitter.once<string>('ready');
    expect(result).toBe('done');
  });

  it('should support once chaining', async () => {
    const emitter = createEventEmitter();

    setTimeout(() => {
      emitter.emit('step1', 'a');
      emitter.emit('step2', 'b');
    }, 10);

    const [a, b] = await Promise.all([
      emitter.once<string>('step1'),
      emitter.once<string>('step2'),
    ]);

    expect(a).toBe('a');
    expect(b).toBe('b');
  });

  it('should clear specific event listeners', () => {
    const emitter = createEventEmitter();
    const callback = jest.fn();

    emitter.on('test', callback);
    emitter.clear('test');
    emitter.emit('test', 'data');

    expect(callback).not.toHaveBeenCalled();
  });

  it('should clear all listeners', () => {
    const emitter = createEventEmitter();
    const cb1 = jest.fn();
    const cb2 = jest.fn();

    emitter.on('event1', cb1);
    emitter.on('event2', cb2);
    emitter.clear();
    emitter.emit('event1', 'a');
    emitter.emit('event2', 'b');

    expect(cb1).not.toHaveBeenCalled();
    expect(cb2).not.toHaveBeenCalled();
  });
});
