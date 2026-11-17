/** Match display labels without changing the canonical type path sent to DM. */
export function spawnSearchMatcher(query: string, regexSearch: boolean) {
  if (regexSearch) {
    const regex = new RegExp(query);
    return (value: string) => regex.test(value);
  }
  const finalizer = query.slice(-1);
  const term = (
    finalizer === '*' || finalizer === '!' ? query.slice(0, -1) : query
  ).toLowerCase();
  return (value: string) => {
    const text = value.toLowerCase();
    const index = text.lastIndexOf(term);
    if (index < 0) return false;
    if (finalizer === '!') return text.endsWith(term);
    if (finalizer === '*') return !text.slice(index).includes('/');
    return true;
  };
}

export function matchesSpawnEntry(
  match: (value: string) => boolean,
  typepath: string,
  name: string,
  displayName: string,
  searchNames: boolean,
) {
  return (
    match(typepath) || (searchNames && (match(name) || match(displayName)))
  );
}
