import { useState } from 'react';

export function useMaskedInput(maskFn, initial = '') {
  const [value, setValue] = useState(initial);

  function onChange(e) {
    setValue(maskFn(e.target.value));
  }

  function reset(v = '') {
    setValue(maskFn(v));
  }

  return { value, onChange, reset, setValue };
}
