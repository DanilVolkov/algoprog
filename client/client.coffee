import "babel-polyfill"

React = require('react')

import { BrowserRouter, Route, Link, Switch } from 'react-router-dom'

ReactDOM = require('react-dom')

import Routes from './routes'
import ScrollToTop from './components/ScrollToTop'
import YaMetrikaHit from './components/YaMetrikaHit'

ReactDOM.render(
    <BrowserRouter>
        <ScrollToTop>
            <YaMetrikaHit>
                <Switch>
                    {Routes.map((route) => `<Route {...route} data={window.__INITIAL_STATE__}/>`)}
                </Switch>
            </YaMetrikaHit>
        </ScrollToTop>
    </BrowserRouter>,
    document.getElementById('main')
)

import observer from './mathJaxObserver'
