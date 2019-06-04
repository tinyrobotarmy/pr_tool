import * as React from 'react'
import { Link } from 'react-router-dom'

import Main from '../components/Main'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

import '../../../node_modules/react-vis/dist/style.css';
import {XYPlot, LineMarkSeries, VerticalGridLines, HorizontalGridLines, XAxis, YAxis, Crosshair} from 'react-vis';

import moment from 'moment'

const MARGIN = {
  left: 50,
  right: 50,
  bottom: 100,
  top: 20
};

interface SeriesItem {
  x: any;
  y: number;
}



interface Repo {
  id: number;
  name: string;
  url: string;
  monthly_series: Array<SeriesItem>
}

// Interface for the Counter component state
interface RepoState {
  repo: Repo
  monthly_series: Array<any>,
  crossshairValues: Array<any>
}

const initialState = { 
  repo: {},
  tickCount: 0,
  monthly_series: [],
  crosshairValues: [{x:null, y: null}], 
}

export default class RepoPage extends React.Component<{}, RepoState> {
  constructor(props: {}) {
    super(props)

    // Set the initial state of the component in a constructor.
    this.state = initialState
    this.onMouseLeave = this.onMouseLeave.bind(this);
    this.onNearestX = this.onNearestX.bind(this);
  }

  componentDidMount() {
    let id = this.props.match.params.id
    fetch('http://localhost:4000/api/git_repos/' + id, {
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Accept': 'application/json',                  
    }})
      .then((results) => {
        return results.json();
      })
      .then((result) => {
        this.setState({
          repo: result.data,
          monthly_series: result.data.monthly_series.map(el => ({x: new Date(el.x), y: el.y.toFixed(2)})),
          tickCount: result.data.length,
          crosshairValues: this.state.crosshairValues,
        })
      })
  }

  onMouseLeave(){
    this.setState({crosshairValues: [{x:null, y: null}]});
  }
  onNearestX(value, {event, innerX, index}) {
    this.setState({
      repo: this.state.repo,
      crosshairValues: [value]
    });
  }

  public render(): JSX.Element {
    return (
      <Main>
        <div className="row">
          <div className="col-sm-1"></div>
          <div className="col-sm-10">
            <h2>Pull Request Data for { this.state.repo.name }</h2>
            <h5 className="sub-head">Rolling 1 month average of time to close a Pull Request</h5>
          </div>
          <div className="col-sm-1"></div>
        </div>
        <div className="row">
          <div className="col-sm-1"></div>
          <div className="col-sm-10"></div>
          <div className="col-sm-1"></div>
        </div>
        <div className="row">
          <div className="col-sm-1"></div>
          <div className="col-sm-10">
            <XYPlot margin={MARGIN} height={400} width={800} onMouseLeave={this.onMouseLeave}>
            <HorizontalGridLines />
            <VerticalGridLines />
            <XAxis
              tickLabelAngle={-45}
              tickTotal={this.state.tickCount}
              tickFormat={d => moment(d).format("MMM YY") }
              style={{
                line: {stroke: '#8b8b8b'},
                ticks: {stroke: '#8b8b8b'},
                text: {stroke: 'none', fill: '#8b8b8b', fontWeight: 800}
              }} />
            <YAxis title="Avg time to close"
              style={{
                line: {stroke: '#8b8b8b'},
                ticks: {stroke: '#8b8b8b'},
                text: {stroke: 'none', fill: '#8b8b8b', fontWeight: 800}
              }}
            />
            <LineMarkSeries curve={'curveMonotoneX'}
              color={'#212ca5'}
              getNull={d => d.y !== null} 
              data={this.state.monthly_series} onNearestX={this.onNearestX}
            />
            <Crosshair values={this.state.crosshairValues} className={'cross'} style={{line:{background: '#3e3e3e'}}}>
              <div>
                <p>Avg Time: {this.state.crosshairValues[0].y}</p>
                <p>On: {moment(this.state.crosshairValues[0].x).format("MMM YY")}</p>
              </div>
            </Crosshair>
            </XYPlot>
          </div>
          <div className="col-sm-1"></div>
        </div>
      </Main>
    )
  }
}