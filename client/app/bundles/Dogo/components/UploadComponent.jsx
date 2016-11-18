import React, { PropTypes } from 'react';
import Dropzone from 'react-dropzone';

export default class UploadComponent extends React.Component {
  static propTypes = {
    updateState: PropTypes.func.isRequired
  };

  constructor(props) {
    super(props);
    this.state = {
      files: this.props.files
    };
  }

  onDrop(files) {
    this.props.updateState({files: files});
    $('input[type=file]').attr('name', 'deck[document]');
    console.log('Received files: ', files);
  }

  render() {
    return (
      <div>
        <Dropzone onDrop={e => this.onDrop(e)} multiple={false} accept={'application/pdf'}>
          <div style={{padding: 15}}>Try dropping your deck pdf here, or click to select files to upload.</div>
        </Dropzone>
      </div>
    );
  }
}
