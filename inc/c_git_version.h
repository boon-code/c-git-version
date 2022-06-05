#ifndef C_GIT_VERSION_H
#define C_GIT_VERSION_H 1

#ifdef __cplusplus
extern "C" {
#endif

extern const char *c_git_hash(void);

extern const char *c_git_version(void);

extern const char *c_git_branch(void);

#ifdef __cplusplus
}
#endif

#endif /* C_GIT_VERSION_H */
