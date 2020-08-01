import React, { useState } from 'react'

import styles from './HelloWorld.scss'

interface Props {
  name: string // this is passed from the Rails view
}

const HelloWorld: React.FC<Props> = (props) => {
  const [name, setName] = useState(props.name)

  return (
    <div>
      <div className={styles.test2}>asfdsadf</div>
      <h3 className="test">Hello, {name}!</h3>
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
