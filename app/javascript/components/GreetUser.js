import React from "react"
import PropTypes from "prop-types"

class GreetUser extends React.Component {
  render() {
    return(
      <div>
        <h2>I feel all empty inside</h2>
        <h1>{this.props.name}</h1>
      </div>
    ) 
  }
}

GreetUser.propTypes = {
  name: PropTypes.string
}

export default GreetUser
