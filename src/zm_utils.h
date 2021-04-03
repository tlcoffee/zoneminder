//
// ZoneMinder General Utility Functions, $Date$, $Revision$
// Copyright (C) 2001-2008 Philip Coombes
// 
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
// 

#ifndef ZM_UTILS_H
#define ZM_UTILS_H

#include <chrono>
#include <ctime>
#include <map>
#include <memory>
#include <stdexcept>
#include <string>
#include <sys/time.h>
#include <vector>

typedef std::vector<std::string> StringVector;

std::string Trim(const std::string &str, const std::string &char_set);
inline std::string TrimSpaces(const std::string &str) { return Trim(str, " \t"); }
std::string ReplaceAll(std::string str, const std::string& old_value, const std::string& new_value);

inline bool StartsWith(const std::string &haystack, const std::string &needle) {
  return (haystack.substr(0, needle.length()) == needle);
}

template<typename... Args>
std::string stringtf(const std::string &format, Args... args) {
  int size = snprintf(nullptr, 0, format.c_str(), args...) + 1; // Extra space for '\0'
  if (size <= 0) {
    throw std::runtime_error("Error during formatting.");
  }
  std::unique_ptr<char[]> buf(new char[size]);
  snprintf(buf.get(), size, format.c_str(), args...);
  return std::string(buf.get(), buf.get() + size - 1); // We don't want the '\0' inside
}

StringVector split( const std::string &string, const std::string &chars, int limit=0 );
const std::string join( const StringVector &, const char * );

const std::string base64Encode( const std::string &inString );
void string_toupper(std::string& str);

int split(const char* string, const char delim, std::vector<std::string>& items);
int pairsplit(const char* string, const char delim, std::string& name, std::string& value);

void* sse2_aligned_memcpy(void* dest, const void* src, size_t bytes);
void timespec_diff(struct timespec *start, struct timespec *end, struct timespec *diff);

void hwcaps_detect();
extern unsigned int sse_version;
extern unsigned int neonversion;

std::string TimevalToString(timeval tv);
std::string UriDecode( const std::string &encoded );
void touch( const char *pathname );

namespace ZM {
//! std::make_unique implementation (TODO: remove this once C++14 is supported)
template<typename T, typename ...Args>
inline auto make_unique(Args &&...args) ->
typename std::enable_if<!std::is_array<T>::value, std::unique_ptr<T>>::type {
  return std::unique_ptr<T>(new T(std::forward<Args>(args)...));
}

template<typename T>
inline auto make_unique(std::size_t size) ->
typename std::enable_if<std::is_array<T>::value && std::extent<T>::value == 0, std::unique_ptr<T>>::type {
  return std::unique_ptr<T>(new typename std::remove_extent<T>::type[size]());
}

template<typename T, typename... Args>
inline auto make_unique(Args &&...) ->
typename std::enable_if<std::extent<T>::value != 0, void>::type = delete;
}

typedef std::chrono::microseconds Microseconds;
typedef std::chrono::milliseconds Milliseconds;
typedef std::chrono::seconds Seconds;
typedef std::chrono::minutes Minutes;
typedef std::chrono::hours Hours;

typedef std::chrono::steady_clock::time_point TimePoint;
typedef std::chrono::system_clock::time_point SystemTimePoint;

class QueryParameter {
  public:
    const std::string &name() const { return name_; }
    const std::string &firstValue() const { return values_[0]; }

    const std::vector<std::string> &values() const { return values_; }
    size_t size() const { return values_.size(); }

    QueryParameter(std::string name) : name_(std::move(name)) { }

    template<class T> void addValue(T&& value) { values_.emplace_back(std::forward<T>(value)); }
  private:
    std::string name_;
    std::vector<std::string> values_;
};

class QueryString {
  public:
    QueryString(std::istream &input);

    size_t size() const { return parameters_.size(); }
    bool has(const char *name) const { return parameters_.find(std::string(name)) != parameters_.end(); }

    std::vector<std::string> names() const;

    const QueryParameter *get(const std::string &name) const;
    const QueryParameter *get(const char* name) const { return get(std::string(name)); };

  private:

    static std::string parseName(std::istream &input);
    static std::string parseValue(std::istream &input);

    std::map<std::string, std::unique_ptr<QueryParameter>> parameters_;
};
#endif // ZM_UTILS_H
