import React, { Component } from "react";
import PropTypes from "prop-types";
import styled from "styled-components";

import Idea from "./Idea";

const __idea = styled.div`
  min-width: 200px;
  min-height: 200px;
  max-width: ${props => (props.isGrid ? "200px" : "none")};
`;

const __feed = styled.div`
  flex-grow: 1;
  margin: 0 auto;
  max-width: 600px;
  position: relative;
  width: 100%;
`;

const __buttonContainer = styled.div`
  align-items: center;
  display: flex;
  flex-direction: row;
  flex-grow: 1;
  justify-content: center;
  margin-bottom: 20px;
`;

const __flexContainer = styled.div`
  align-items: center;
  display: flex;
  flex-wrap: wrap;
  flex-flow: row wrap;
  padding: 0.75em;

  @media (max-width: 640px) {
    justify-content: center;
  }

  > span {
    padding-left: 0.5em;
  }
`;

const __gridButton = styled.div`
  cursor: pointer;
  background: ${props => (props.isGrid ? "#E7E7E7" : "initial")};

  @media (max-width: 640px) {
    flex-grow: 1;
  }
`;

const __listButton = styled.div`
  cursor: pointer;
  background: ${props => (props.isGrid ? "initial" : "#E7E7E7")};

  @media (max-width: 640px) {
    flex-grow: 1;
  }
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
        strokeWidth="2"
        strokeLinecap="round"
        strokeLinejoin="round"
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
        strokeWidth="2"
        strokeLinecap="round"
        strokeLinejoin="round"
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
  flex-wrap: wrap;
`;

class Feed extends Component {
  constructor(props) {
    super(props);
    this.state = {
      isGrid: false
    };
  }

  componentWillMount() {
    let renderIdeas = this.props.ideas;
  }

  handleGridButtonClick() {
    this.setState({ isGrid: true });
  }

  handleListButtonClick() {
    this.setState({ isGrid: false });
  }

  render() {
    return (
      <__feed>
        <div>
          <__buttonContainer>
            <__gridButton
              onClick={this.handleGridButtonClick.bind(this)}
              isGrid={this.state.isGrid}
            >
              <GridButton />
            </__gridButton>
            <__listButton
              onClick={this.handleListButtonClick.bind(this)}
              isGrid={this.state.isGrid}
            >
              <ListButton />
            </__listButton>
          </__buttonContainer>
        </div>
        <__grid isGrid={this.state.isGrid}>
          {this.props.ideas.map(idea => (
            <__idea isGrid={this.state.isGrid}>
              <Idea
                key={idea.id}
                name={idea.name}
                imageUrl={idea.image_url}
                date={idea.created_at}
                imageData={idea.image_data}
              />
            </__idea>
          ))}
        </__grid>
      </__feed>
    );
  }
}

Feed.propTypes = {
  isGrid: PropTypes.bool,
  ideas: PropTypes.array
};

export default Feed;
