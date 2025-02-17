// MyReactComponent.jsx
/* eslint-disable */
import React, { useEffect } from 'react';

function MyReactComponent() {
  useEffect(() => {
    console.log('MyReactComponent has been mounted');
  }, []);

  return (
    <div>
      <h1>Hello from React!</h1>
    </div>
  );
}

export default MyReactComponent;
