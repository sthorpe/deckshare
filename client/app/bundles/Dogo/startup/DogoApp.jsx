import React from 'react';
import ReactOnRails from 'react-on-rails';

import DeckContainer from '../containers/DeckContainer';

const DogoApp = (props) => (
  <DeckContainer {...props} />
);

// This is how react_on_rails can see the HelloWorldApp in the browser.
ReactOnRails.register({ DogoApp });
