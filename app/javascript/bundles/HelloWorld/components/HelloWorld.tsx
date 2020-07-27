import React, { useState } from 'react'

interface Props {
  name: string // this is passed from the Rails view
}

const HelloWorld: React.FC<Props> = (props) => {
  const [name, setName] = useState(props.name)

  return (
    <div>
      <h3>Hello, {name}!</h3>
      <hr />
      <form>
        <label htmlFor="name">
          Say hello to:{' '}
          <input
            id="name"
            type="text"
            value={name}
            onChange={(e) => setName(e.target.value)}
          />
        </label>
      </form>
    </div>
  )
}

export default HelloWorld
