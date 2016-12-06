import React from 'react';
import ReactOnRails from 'react-on-rails';

//import DeckContainer from '../containers/DeckContainer';
import ContactsSuggest from '../components/ContactsSuggest';

const DogoApp = (props) => (
  <ContactsSuggest {...props} />
);

// This is how react_on_rails can see the HelloWorldApp in the browser.
ReactOnRails.register({ DogoApp });
