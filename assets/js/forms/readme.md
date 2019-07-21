# Xplor form components


Setting `maxLength` on a FormInput for FormTextarea triggers the display of a counter



```javascript

  <form id="login-form" onSubmit={this.handleSubmit}>
    <fieldset>
      <FormInput 
        required={true} 
        label="Email or Username"
        name="email"
        autoFocus="true"
        onChange={this.handleChange}
      />
      <FormInput 
        name="password" 
        type="password" 
        onChange={this.handleChange}
      />
    </fieldset>
  </form>

```