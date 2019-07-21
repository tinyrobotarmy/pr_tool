import React from 'react'
import {storiesOf} from '@storybook/react'
// import {} from '@storybook/addon-actions'

import {Card, FormInput} from '../../'

storiesOf('Form input', module)
  .add('basic', () => (
    <Card>
      <form>
        <fieldset>
          <FormInput 
            name="first_name"
            label="First Name"
          />
        </fieldset>
      </form>
    </Card>
  ))
  .add('is required', () => (
    <Card>
      <form>
        <fieldset>
          <FormInput 
            name="first_name"
            label="First Name"
            required={true}
          />
        </fieldset>
      </form>
    </Card>
  ))
  .add('with hint', () => (
    <Card>
      <form>
        <fieldset>
          <FormInput 
            name="first_name"
            label="First Name"
            required={true}
            hint="What people normally call you"
          />
        </fieldset>
      </form>
    </Card>
  ))
  .add('with hint and counter', () => (
    <Card>
      <form>
        <fieldset>
          <FormInput 
            name="first_name"
            label="First Name"
            required={true}
            maxLength={12}
            hint="What people normally call you"
          />
        </fieldset>
      </form>
    </Card>
  ))
  .add('with errors', () => (
    <Card>
      <form>
        <fieldset>
          <FormInput 
            name="first_name"
            label="First Name"
            required={true}
            maxLength={12}
            hint="What people normally call you"
            errors={['This needs to be filled out']}
          />
        </fieldset>
      </form>
    </Card>
  ))
  .add('with errors (but form is loading/submitting)', () => (
    <Card>
      <form>
        <fieldset>
          <FormInput 
            name="first_name"
            label="First Name"
            required={true}
            maxLength={12}
            hint="What people normally call you"
            errors={['This needs to be filled out']}
            loading={true}
          />
        </fieldset>
      </form>
    </Card>
  ))