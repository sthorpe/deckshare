import React, { PropTypes } from 'react';
import Autosuggest from 'react-autosuggest';

// https://developer.mozilla.org/en/docs/Web/JavaScript/Guide/Regular_Expressions#Using_Special_Characters
const escapeRegexCharacters = str => str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');

const getSuggestionValue = suggestion => suggestion;

//const renderSuggestion = suggestion => suggestion;
function renderSuggestion(suggestion) {
  return (
    <div>
      <div>{suggestion["name"]}</div>
      <div>{suggestion["email"]}</div>
      <div>{suggestion["bio"]}</div>
      <div>{suggestion["location"]}</div>
      <div>{suggestion["site"]}</div>
    </div>
  );
}

const renderInputComponent = inputProps => (
  <div className="inputContainer">
    <img className="icon" src="https://cdn4.iconfinder.com/data/icons/small-n-flat/24/user-alt-128.png" />
    <input {...inputProps} />
  </div>
);

export default class ContactsSuggest extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      value: '',
      suggestions: []
    };
  }

  onChange = (event, { newValue, method }) => {
    this.setState({
      value: newValue
    });
  };

  onSuggestionsFetchRequested = ({ value }) => {
    this.setState({
      suggestions: this.getSuggestions(value)
    });
  };

  getSuggestions = (value) => {
    const escapeRegexCharacters = str => str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    const escapedValue = escapeRegexCharacters(value.trim());
    if (escapedValue === '') {
      return [];
    }

    const regex = new RegExp('^' + escapedValue, 'i');

    var contacts = [];
    $.each(this.props.contacts, function( index, value ) {
      contacts.push(value);
    });

    return contacts.filter(contact => regex.test(contact["name"]));
  }

  onSuggestionsClearRequested = () => {
    this.setState({
      suggestions: []
    });
  };

  render() {
    const { value, suggestions } = this.state;
    const inputProps = {
      placeholder: "Enter a name",
      value,
      onChange: this.onChange
    };

    return (
      <Autosuggest
        suggestions={suggestions}
        onSuggestionsFetchRequested={this.onSuggestionsFetchRequested}
        onSuggestionsClearRequested={this.onSuggestionsClearRequested}
        getSuggestionValue={getSuggestionValue}
        renderSuggestion={renderSuggestion}
        inputProps={inputProps}
        renderInputComponent={renderInputComponent}
      />
    );
  }
}
