import React, { Component } from "react";
import PropTypes from "prop-types";
import styled from "styled-components";
import Moment from "react-moment";

const Image = styled.img`
  align-self: stretch;
  flex: 1;
`;

const Name = styled.div``;

const STimeStamp = styled.div`
  align-items: center;
  color: #bbb;
  display: flex;
  font-size: 0.7em;
  padding-left: 0.3em;
`;

const Flex = styled.div`
  display: flex;
`;

class Idea extends Component {
  render() {
    let imageData = JSON.parse(this.props.imageData);

    let width = imageData.metadata.width || null;
    let height = imageData.metadata.height || null;

    const TimeStamp = ({ date }) => {
      return (
        <STimeStamp>
          <Moment fromNow>{this.props.date}</Moment>
        </STimeStamp>
      );
    };

    if (this.props.imageUrl) {
      return (
        <div>
          <Image
            alt={this.props.name}
            src={this.props.imageUrl}
            width={width}
            height={height}
            resizeMode={"contain"}
          />
          <Flex>
            <Name>{this.props.name}</Name>
            <TimeStamp />
          </Flex>
        </div>
      );
    } else {
      return (
        <Flex>
          <Name>💡 {this.props.name}</Name>
          <TimeStamp />
        </Flex>
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
