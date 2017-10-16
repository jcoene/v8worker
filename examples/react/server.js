import React from 'react';
import ReactDOMServer from 'react-dom/server';

const Widget = ({name, timestamp}) => {
  return (
    <div className="Widget">{name} at {timestamp}</div>
  );
}

$recv(function(msg) {
  try {
    const req = JSON.parse(msg);
    const el = React.createElement(Widget, req.props);
    const html = ReactDOMServer.renderToString(el);
    $send(JSON.stringify({html: html}));
  } catch(err) {
    $send(JSON.stringify({error: err.message}));
  }
});
