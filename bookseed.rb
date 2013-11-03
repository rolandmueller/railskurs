# ruby encoding: utf-8

Book.create(:title => 'Homo faber').authors.create(:first_name => 'Max', :last_name => 'Frisch')
Book.create(:title => 'Der Besuch der alten Dame').authors.create(:first_name => 'Friedrich', :last_name => 'Dürrenmatt')
Book.create(:title => 'Julius Shulman: The Last Decade').authors.create([
  {:first_name => 'Thomas', :last_name => 'Schirmbock'},
  {:first_name => 'Julius', :last_name => 'Shulman'},
  {:first_name => 'Jürgen', :last_name => 'Nogai'}
  ])
Book.create(:title => 'Julius Shulman: Palm Springs').authors.create([
  {:first_name => 'Michael', :last_name => 'Stern'},
  {:first_name => 'Alan', :last_name => 'Hess'}
  ])
Book.create(:title => 'Photographing Architecture and Interiors').authors.create([
  {:first_name => 'Julius', :last_name => 'Shulman'},
  {:first_name => 'Richard', :last_name => 'Neutra'}
  ])
Book.create(:title => 'Der Zauberberg').authors.create(:first_name => 'Thomas', :last_name => 'Mann')
Book.create(:title => 'In einer Familie').authors.create(:first_name => 'Heinrich', :last_name => 'Mann')
