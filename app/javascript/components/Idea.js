import React, { Component } from "react";
import PropTypes from "prop-types";
import styled from "styled-components";
import Moment from "react-moment";

const __description = styled.div`
  padding: 8px 16px;
`

const __idea = styled.div`
  margin-bottom: 60px;

  @media(min-width: 640px) {
    border-radius: 3px;
    border: 1px solid #e6e6e6;
  }
`

const Image = styled.img`
  align-self: stretch;
  flex: 1;
  height: 100%;
  width: 100%;
`;

const Name = styled.div``;

const STimeStamp = styled.div`
  color: #bbb;
  font-size: 0.7em;
`;

const Flex = styled.div`
  display: flex;
`;

class Idea extends Component {
  componentWillMount() {
    if (this.props.imageData) {
      let imageData = JSON.parse(this.props.imageData);

      this.setState({
        height: imageData.metadata.height,
        width: imageData.metadata.width
      });
    }
  }

  render() {
    const TimeStamp = ({ date }) => {
      return (
        <STimeStamp>
          <Moment fromNow>{this.props.date}</Moment>
        </STimeStamp>
      );
    };

    if (this.props.imageUrl) {
      return (
        <__idea>
          <div>
            <Image
              alt={this.props.name}
              src={this.props.imageUrl}
              height={this.state.height}
              width={this.state.width}
              resizeMode={"contain"}
            />
          </div>
          <__description>
            <Name>{this.props.name}</Name>
            <TimeStamp />
          </__description>
        </__idea>
      );
    } else {
      return (
        <__idea>
          <Name>{this.props.name}</Name>
          <TimeStamp />
        </__idea>
      );
    }
  }
}

Idea.propTypes = {
  name: PropTypes.string,
  imageUrl: PropTypes.string,
  date: PropTypes.string,
  imageData: PropTypes.string
};

export default Idea;
