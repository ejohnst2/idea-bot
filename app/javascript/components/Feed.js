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
`;

const __flexContainer = styled.div`
  align-items: center;
  display: flex;
  padding: 0.75em;

  > span {
    padding-left: 0.5em;
  }
`

const __break = styled.div`
  padding: 0 0.35em;
`

const __gridButton = styled.div`
  cursor: pointer;
  background: ${props => (props.isGrid ? "green" : "initial")};
`;

const __listButton = styled.div`
  cursor: pointer;
  background: ${props => (props.isGrid ? "initial" : "green")};
`;

function GridButton() {
  return (
    <__flexContainer>
      <svg
        xmlns="http://www.w3.org/2000/svg"
        width="24"
        height="24"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        stroke-width="2"
        stroke-linecap="round"
        stroke-linejoin="round"
      >
        <rect x="3" y="3" width="7" height="7" />
        <rect x="14" y="3" width="7" height="7" />
        <rect x="14" y="14" width="7" height="7" />
        <rect x="3" y="14" width="7" height="7" />
      </svg>
      <span>GRID</span>
    </__flexContainer>
  );
}

function ListButton() {
  return (
    <__flexContainer>
      <svg
        xmlns="http://www.w3.org/2000/svg"
        width="24"
        height="24"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        stroke-width="2"
        stroke-linecap="round"
        stroke-linejoin="round"
      >
        <line x1="8" y1="6" x2="21" y2="6" />
        <line x1="8" y1="12" x2="21" y2="12" />
        <line x1="8" y1="18" x2="21" y2="18" />
        <line x1="3" y1="6" x2="3" y2="6" />
        <line x1="3" y1="12" x2="3" y2="12" />
        <line x1="3" y1="18" x2="3" y2="18" />
      </svg>
      <span>LIST</span>
    </__flexContainer>
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

  handleGridButtonClick() {
    this.setState({ isGrid: true });
    console.log("gridButtonClick", this.state.isGrid);
  }

  handleListButtonClick() {
    this.setState({ isGrid: false });
    console.log("listButtonClick", this.state.isGrid);
  }

  render() {
    return (
      <div>
        <div>
          <__buttonContainer>
            <__gridButton
              onClick={this.handleGridButtonClick.bind(this)}
              isGrid={this.state.isGrid}
            >
              <GridButton />
            </__gridButton>
            <__break />
            <__listButton
              onClick={this.handleListButtonClick.bind(this)}
              isGrid={this.state.isGrid}
            >
              <ListButton />
            </__listButton>
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
