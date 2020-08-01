import React from 'react'

// import { Provider } from 'react-redux'
// import ReactOnRails from 'react-on-rails'
import HelloWorld from '../components/HelloWorld'

export default (_props, _railsContext) => {
  // const store = ReactOnRails.getStore('myStore')

  // return (
  //   <Provider store={store}>
  //     <HelloWorld />
  //   </Provider>
  // )
  return <HelloWorld name="test" />
}
