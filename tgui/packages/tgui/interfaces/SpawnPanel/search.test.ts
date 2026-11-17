import { describe, expect, test } from 'bun:test';
import { matchesSpawnEntry, spawnSearchMatcher } from './search';

const path = '/obj/item/tool/wrench';
const name = 'wrench';
const displayName = '扳手';
const matches = (query: string, regex = false, names = true) =>
  matchesSpawnEntry(
    spawnSearchMatcher(query, regex),
    path,
    name,
    displayName,
    names,
  );

describe('admin spawn search', () => {
  test('Chinese, English and canonical type paths select the same entry', () => {
    expect(matches('扳手')).toBe(true);
    expect(matches('WRENCH')).toBe(true);
    expect(matches('/obj/item/tool/')).toBe(true);
    expect(path).toBe('/obj/item/tool/wrench');
  });
  test('path-only mode excludes translated names', () => {
    expect(matches('扳手', false, false)).toBe(false);
    expect(matches('wrench', false, false)).toBe(true);
  });
  test('regex matches either language and type paths', () => {
    expect(matches('^扳.*$', true)).toBe(true);
    expect(matches('^wrench$', true)).toBe(true);
    expect(matches('^/obj/item', true, false)).toBe(true);
    expect(matches('^wrench$', true, false)).toBe(false);
    expect(() => matches('[', true)).toThrow();
  });
  test('suffix and leaf-path searches preserve existing semantics', () => {
    expect(matches('扳手!')).toBe(true);
    expect(matches('wrench*')).toBe(true);
    expect(matches('tool*', false, false)).toBe(false);
    expect(matches('wrench!', false, false)).toBe(true);
    expect(matches('扳!', false)).toBe(false);
  });
});
