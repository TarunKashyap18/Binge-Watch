import 'package:bloc/bloc.dart';

import '../../../../data/fetch_search_results.dart';
import '../../../../models/movie_model.dart';
import '../../../../models/people_model.dart';
import '../../../../models/tv_model.dart';

part 'search_results_state.dart';

class SearchResultsCubit extends Cubit<SearchResultsState> {
  SearchResultsCubit() : super(SearchResultsState.initial());

  final repo = SearchResultsRepo();

  void init(String query) async {
    try {
      emit(state.copyWith(movieStatus: MovieStatus.loading, query: query));
      final movies = await repo.getmovies(query, state.moviePage);
      emit(
        state.copyWith(
          movieStatus: MovieStatus.loaded,
          movies: movies[0],
          moviePage: state.moviePage + 1,
        ),
      );
    } catch (e) {
      emit(state.copyWith(movieStatus: MovieStatus.error));
    }
  }

  void loadNextMoviePage() async {
    if (!state.moviesFull) {
      emit(state.copyWith(movieStatus: MovieStatus.adding));
      final movies = await repo.getmovies(state.query, state.moviePage);
      state.movies.addAll(movies[0]);
      emit(
        state.copyWith(
          movies: state.movies,
          moviePage: state.moviePage + 1,
          moviesFull: movies[1] != state.moviePage,
        ),
      );
    } else {
      emit(state.copyWith(movieStatus: MovieStatus.allfetched));
    }
  }

  void loadNextTvPage() async {
    if (!state.tvFull) {
      emit(state.copyWith(tvStatus: TvStatus.adding));
      final shows = await repo.gettvShows(state.query, state.tvPage);
      state.shows.addAll(shows[0]);
      emit(
        state.copyWith(
          shows: state.shows,
          tvPage: state.tvPage + 1,
          tvFull: shows[1] != state.tvPage,
        ),
      );
    } else {
      emit(state.copyWith(tvStatus: TvStatus.allfetched));
    }
  }

  void loadNextPersonPage() async {
    if (!state.moviesFull) {
      emit(state.copyWith(peopleStatus: PeopleStatus.adding));
      final people = await repo.getPersons(state.query, state.peoplePage);
      state.people.addAll(people[0]);
      emit(state.copyWith(
        people: state.people,
        peopleFull: people[1] != state.peoplePage,
        peoplePage: state.peoplePage + 1,
      ));
    } else {
      emit(state.copyWith(peopleStatus: PeopleStatus.allfetched));
    }
  }

  void initTv(String query) async {
    try {
      emit(state.copyWith(tvStatus: TvStatus.loading));
      final shows = await repo.gettvShows(query, state.tvPage);
      emit(
        state.copyWith(
          tvStatus: TvStatus.loaded,
          shows: shows[0],
          tvPage: state.tvPage + 1,
        ),
      );
    } catch (e) {
      // print(e.toString());
      emit(state.copyWith(tvStatus: TvStatus.error));
    }
  }

  void initPeople(String query) async {
    try {
      emit(state.copyWith(peopleStatus: PeopleStatus.loading));
      final people = await repo.getPersons(query, state.peoplePage);
      emit(
        state.copyWith(
          peopleStatus: PeopleStatus.loaded,
          people: people[0],
          peoplePage: state.peoplePage + 1,
        ),
      );
    } catch (e) {
      // print(e.toString());
      emit(state.copyWith(
        peopleStatus: PeopleStatus.error,
      ));
    }
  }
}
