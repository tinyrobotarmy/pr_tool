import React from 'react'
import {storiesOf} from '@storybook/react'

import {Card, FormTextArea} from '../../'

storiesOf('Form textarea', module)
  .add('basic', () => (
    <Card>
      <form>
        <fieldset>
          <FormTextArea 
            name="message"
            label="Your message"
          />
        </fieldset>
      </form>
    </Card>
  ))
  .add('is required', () => (
    <Card>
      <form>
        <fieldset>
          <FormTextArea 
            name="message"
            label="Your message"
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
          <FormTextArea 
            name="message"
            label="Your message"
            required={true}
            hint="Say something nice"
          />
        </fieldset>
      </form>
    </Card>
  ))
  .add('with hint and counter', () => (
    <Card>
      <form>
        <fieldset>
          <FormTextArea 
            name="message"
            label="Your message"
            required={true}
            maxLength={256}
            hint="Say something nice"
          />
        </fieldset>
      </form>
    </Card>
  ))
  .add('with errors', () => (
    <Card>
      <form>
        <fieldset>
          <FormTextArea 
            name="message"
            label="Your message"
            required={true}
            maxLength={256}
            hint="Say something nice"
            errors={['This needs to be filled out']}
          />
        </fieldset>
      </form>
    </Card>
  ))
  .add('with errors and submitting', () => (
    <Card>
      <form>
        <fieldset>
          <FormTextArea 
            name="message"
            label="Your message"
            required={true}
            maxLength={256}
            hint="Say something nice"
            errors={['This needs to be filled out']}
            loading={true}
          />
        </fieldset>
      </form>
    </Card>
  ))