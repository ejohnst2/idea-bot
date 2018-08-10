import React, { Component } from "react";
import PropTypes from "prop-types";
import styled from "styled-components";
import Moment from "react-moment";

const Image = styled.img`
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
        <div>
          <Image alt={this.props.name} src={this.props.imageUrl} />
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
  date: PropTypes.string
};

export default Idea;
