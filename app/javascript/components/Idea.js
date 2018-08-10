import React from "react"
import PropTypes from "prop-types"
import styled from "styled-components"

const Image = styled.img`
  height: 100%;
  width: 100%;
`

const Name = styled.div``

const Date = styled.div``

class Idea extends React.Component {
  render() {
    return (
      <div>
        <Image alt={this.props.name} src={this.props.imageUrl} />
        <Name>{this.props.name}</Name>
        <Date>{this.props.date}</Date>
      </div>
    )
  }
}

Idea.propTypes = {
  name: PropTypes.string,
  imageUrl: PropTypes.string,
  date: PropTypes.string
}

export default Idea
