// assets/js/components/Header.tsx

import * as React from 'react'

const Header: React.FC = () => (
  <header>
    <section className="container">
      <nav role="navigation" className="navbar-expand-lg navbar-light bg-light">
        <div className="collapse navbar-collapse" id="navbarSupportedContent">
          <ul className="navbar-nav mr-auto">
            <li className="nav-item active">
              <a className="nav-link" href="/">Home <span className="sr-only">(current)</span></a>
            </li>
            <li className="nav-item">
              <a className="nav-link" href="/pulls">Pull Requests</a>
            </li>
          </ul>
        </div>
      </nav>
      <a href="/" className="logo">
        <img src="/images/logo.png" alt="Tinyrobotarmy Logo" />
      </a>
    </section>
  </header>
)

export default Header