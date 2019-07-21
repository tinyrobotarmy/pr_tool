const handleChange = (onChange, callback) => (event) => {
  const result = onChange(event.target.name, event.target.value)
  return callback ? callback(event) : result
}

const idFromName = (name) => {
  return `form-input-${name.replace(/\s/g,'-')}`
}

export {
  handleChange,
  idFromName
}