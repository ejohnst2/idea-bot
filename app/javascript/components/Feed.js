import React, { Component } from "react";
import PropTypes from "prop-types";
import styled from "styled-components";

import { Idea } from "./Idea";

const __buttonContainer = styled.div`
  align-items: center;
  display: flex;
  flex-direction: row;
  flex-grow: 1;
  justify-content: center;
`

const __gridButton = styled.svg`
  cursor: pointer;
`;

const __listButton = styled.svg`
  cursor: pointer;
`;

function GridButton() {
  return (
    <__gridButton
      xmlns="http://www.w3.org/2000/svg"
      width="24"
      height="24"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      stroke-width="2"
      stroke-linecap="round"
      stroke-linejoin="round"
      className="feather feather-grid"
    >
      <rect x="3" y="3" width="7" height="7" />
      <rect x="14" y="3" width="7" height="7" />
      <rect x="14" y="14" width="7" height="7" />
      <rect x="3" y="14" width="7" height="7" />
    </__gridButton>
  );
}

function ListButton() {
  return (
    <__listButton
      xmlns="http://www.w3.org/2000/svg"
      width="24"
      height="24"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      stroke-width="2"
      stroke-linecap="round"
      stroke-linejoin="round"
      className="feather feather-list"
    >
      <line x1="8" y1="6" x2="21" y2="6" />
      <line x1="8" y1="12" x2="21" y2="12" />
      <line x1="8" y1="18" x2="21" y2="18" />
      <line x1="3" y1="6" x2="3" y2="6" />
      <line x1="3" y1="12" x2="3" y2="12" />
      <line x1="3" y1="18" x2="3" y2="18" />
    </__listButton>
  );
}

const __grid = styled.div`
  display: flex;
  flex-direction: ${props => (props.isGrid ? "row" : "column")};
`;

class Feed extends Component {
  constructor(props) {
    super(props);
    this.state = {
      isGrid: true
    };
  }

  handleClick() {
    console.log(this.state.isGrid);
    this.setState({ isGrid: !this.state.isGrid });
  }

  render() {
    return (
      <div>
        <div onClick={this.handleClick.bind(this)}>
          <__buttonContainer>
            <GridButton />
            <ListButton />
          </__buttonContainer>
        </div>
        <__grid isGrid={this.state.isGrid} />
      </div>
    );
  }
}

Feed.propTypes = {
  isGrid: PropTypes.bool
};

export default Feed;
