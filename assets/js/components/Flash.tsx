import React, { useEffect, useState } from 'react';
import Bus from '../Utils/Bus';

export const Flash = () => {
    let [visibility, setVisibility] = useState(false);
    let [message, setMessage] = useState('');
    let [type, setType] = useState('');

    useEffect(() => {
        Bus.addListener('flash', ({ message, type }) => {
            setVisibility(true);
            setMessage(message);
            setType(type);
            setTimeout(() => {
                setVisibility(false);
            }, 4000);
        });


    }, []);

    useEffect(() => {
        if (document.querySelector('.close') !== null) {
            document.
                querySelector('.closer').
                addEventListener('click', () => setVisibility(false));
        }
    })

    return (
        visibility && <div className={`alert alert-${type}`}>
            <div className="closer">X</div>
            <p>{message}</p>
        </div>
    )
}

export default Flash