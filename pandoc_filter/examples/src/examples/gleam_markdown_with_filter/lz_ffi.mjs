
import lz from 'lz-string';

export function makeV1Hash(code) {
  return lz.compressToBase64(
    JSON.stringify({
      version: 1,
      content: code,
    }),
  );
}
