React = require('react')
$ = require('jquery');

import { Grid } from 'react-bootstrap'

import CfStatus from './CfStatus'
import UserName from './UserName'

export default UserBadge = (props) ->
    <div>
        <h1>
            <UserName user={props.user}/>
        </h1>
        <blockquote>
            <div>Уровень: {props.user.level.current}</div>
            <div>Рейтинг: {props.user.rating}</div>
            <div>Активность: {props.user.activity}</div>
            { props.user.cf?.login && 
                <div> Codeforces рейтинг: <CfStatus cf={props.user.cf}/> </div> }
        </blockquote>
    </div>