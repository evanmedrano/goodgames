import React, { useEffect, useState } from 'react';

import axios from 'axios';

// import SearchItem from './SearchItem';

function SearchBar() {
  const [results, setResults] = useState([]);
  const [query, setQuery] = useState('');

  useEffect(() => {
    if (query) {
      axios({
        method: 'get',
        url: `http://localhost:3000/games?query=${query}`,
        headers: { 'Accept': 'application/json' },
        responseType: 'json'
      })
      .then(response => setResults(response.data))
      .catch(error => console.log(error))
    }
    console.log(userIsTyping)
  }, [query])

  const handleChange = (event) => {
    setQuery(event.target.value);
  }

  const handleSearch = () => {
    axios({
      method: 'get',
      url: `http://localhost:3000/games?query=${query}`,
    })
  }

  const searchResults = results.map(item => {
    return (
      <li key={item.id}>{item.name}</li>
    )
   })

  return (
    <div className="d-flex justify-content-center mt-5 mb-4">
      <form
        id="game-search"
        className="form-inline my-2 my-lg-0"
        onSubmit={handleSearch}
      >
        <input
          type="text"
          value={query}
          placeholder="Search 347, 170 games!"
          id="query"
          className="form-control"
          onChange={handleChange}
        />
      </form>

      <div className="mt-5">
        <ul>{query ? searchResults : ''}</ul>
      </div>
    </div>
  )
}

export default SearchBar;
