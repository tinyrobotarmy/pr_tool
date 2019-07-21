import {idFromName, handleChange} from '../index'

describe('Forms actions idFromName', () => {
  it('should ', () => {
    expect(idFromName('First Name')).toEqual('form-input-First-Name')
  })

  it('should replace all blank spaces', () => {
    expect(idFromName('Username - password')).toEqual('form-input-Username---password')
  })
})


describe('Forms action handleChange', () => {
  const onChangeFn = jest.fn()
  const callbackFn = jest.fn()
  const invoke = handleChange(onChangeFn, callbackFn)

  it('should call onChange with event name and message', () => {
    invoke(({
      target: {
        name: 'testing-message',
        value: 'Testing 123'
      }
    }))

    expect(onChangeFn).toHaveBeenCalledWith('testing-message', 'Testing 123')
  })

  it('should call the callbackFn with the event', () => {
    const event = {
      target: {
        name: 'testing-message',
        value: 'Testing 123'
      }
    }
    invoke(event)
    
    expect(callbackFn).toHaveBeenCalledWith(event)
  })
})