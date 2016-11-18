import React, { PropTypes } from 'react';
import UploadComponent from '../components/UploadComponent';

export default class Deck extends React.Component {
  static propTypes = {
    name: PropTypes.string.isRequired,
  };

  constructor(props, context) {
    super(props, context);
    this.state = {
      files: this.props.files
    };
  }

  updateState(state) {
    this.setState({
      files: state.files
    });
  }

  render() {
    return (
      <div>
        {this.state.files ? <div>
            <h4>{this.state.files[0].name}</h4>
          </div> :
          <UploadComponent updateState={e => this.updateState(e)} />
        }
      </div>
    );
  }
}
